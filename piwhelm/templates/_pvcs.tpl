{{- define "piwhelm.manifest.pvcs" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- if hasKey $dict "pvcs" }}
{{- range $dict.pvcs }}
{{- if .enabled -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ .name | default (printf "%s-pvc" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
spec:
  storageClassName: {{ .storageClassName | default "" }}
  volumeName: {{ .volumeName | default "" }}
  accessModes: {{ .accessModes | default "[]" }}
  resources:
    requests:
        storage: {{ .storage }}
---
{{- end }}
{{- end }}
{{- end }}
{{- end }}
