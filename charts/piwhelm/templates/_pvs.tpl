{{- /*
  Template: piwhelm.manifest.pvs
  Renders PersistentVolume resources from values.yaml
  Usage: Fails fast if required values are missing. Uses sensible defaults and robust referencing.
*/}}
{{- define "piwhelm.manifest.pvs" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- if hasKey $dict "pvs" }}
{{- range $dict.pvs }}
{{- if .enabled -}}
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: {{ .name | required "Missing name in pv" }}
{{- include "metadata" $ | indent 2 }}
spec:
  {{- if .storageClassName }}
  storageClassName: {{ .storageClassName }}
  {{- end }}
  capacity:
    storage: {{ .capacity.storage | required "Missing capacity.storage in pv" }}
  accessModes: {{ .accessModes | default list }}
  persistentVolumeReclaimPolicy: {{ .persistentVolumeReclaimPolicy | default "Delete" }}
  {{- if .nfs }}
  nfs:
    path: {{ .nfs.path | required "Missing nfs.path in pv" }}
    server: {{ .nfs.server | required "Missing nfs.server in pv" }}
    readOnly: {{ .nfs.readOnly | default false }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
