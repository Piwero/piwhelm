{{- define "piwhelm.manifest.pvs" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- if hasKey $dict "pvs" }}
{{- range $dict.pvs }}
{{- if .enabled -}}
apiVersion: v1
kind: PersistentVolume
metadata:
  name: {{ .name | default (printf "%s-config" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
spec:
  storageClassName: {{ .storageClassName | default "" | indent 2 }}
  capacity:
    storage: {{ .capacity.storage }}
{{ toYaml .accessmodes | indent 4 }}
  persistentVolumeReclaimPolicy: {{ .persistentVolumeReclaimPolicy | default "Delete" }}
  nfs:
    path: {{ .nfs.path}}
    server: {{ .nfs.server}}
    readOnly: {{ .nfs.readOnly }}
---
{{- end }}
{{- end }}
{{- end }}
{{- end }}
