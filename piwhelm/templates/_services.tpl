{{- define "piwhelm.manifest.services" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- if hasKey $dict "services" }}
{{- range $dict.services }}
{{- if .enabled -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .name | default (printf "%s-config" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
spec:
{{- include "selector" $ | indent 4 }}
    type: {{ .type | default "ClusterIP" }}
    ports:
{{ toYaml .ports | indent 4 }}
---
{{- end }}
{{- end }}
{{- end }}
{{- end }}