{{- define "piwhelm.manifest.services" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- if hasKey $dict "services" }}
{{- range $dict.services }}
{{- if .enabled -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .name | default (printf "%s-svc" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
spec:
    selector:
        chart: {{ $.Chart.Name }}
    type: {{ .type | default "ClusterIP" }}
    ports:
{{ toYaml .ports | indent 4 }}
---
{{- end }}
{{- end }}
{{- end }}
{{- end }}