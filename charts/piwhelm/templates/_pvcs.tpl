{{- /*
  Template: piwhelm.manifest.pvcs
  Renders PersistentVolumeClaim resources from values.yaml
  Usage: Fails fast if required values are missing. Uses sensible defaults and robust referencing.
*/}}
{{- define "piwhelm.manifest.pvcs" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- if hasKey $dict "pvcs" }}
{{- range $dict.pvcs }}
{{- if .enabled -}}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ .name | required "Missing name in pvc" }}
{{- include "metadata" $ | indent 2 }}
spec:
  {{- if .storageClassName }}
  storageClassName: {{ .storageClassName }}
  {{- end }}
  {{- if .volumeName }}
  volumeName: {{ .volumeName }}
  {{- end }}
  accessModes: {{ .accessModes | default list }}
  resources:
    requests:
      storage: {{ .storage | required "Missing storage in pvc" }}
  {{- if .volumeMode }}
  volumeMode: {{ .volumeMode }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
