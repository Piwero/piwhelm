{{- define "piwhelm.manifest.pvs" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- if hasKey $dict "pvs" }}
{{- range $dict.pvs }}
{{- if .enabled -}}
apiVersion: v1
kind: PersistentVolume
metadata:
  name: {{ .name | default (printf "%s-pv" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
spec:
{{- if .storageClassName }}
  storageClassName: {{ .storageClassName | default "" }}{{- end }}
  {{- end }}
  capacity:
    storage: {{ .capacity.storage }}
  accessModes: {{ .accessModes | default "[]" }}
  persistentVolumeReclaimPolicy: {{ .persistentVolumeReclaimPolicy | default "Delete" }}
  nfs:
    path: {{ .nfs.path}}
    server: {{ .nfs.server}}
    readOnly: {{ .nfs.readOnly }}
---
{{- end }}
{{- end }}
{{- end }}
