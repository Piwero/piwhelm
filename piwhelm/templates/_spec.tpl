{{- define "spec" }}
{{- include "selector" . }}
{{- end }}

{{- define "selector" }}
selector:
    matchLabels:
        chart: {{ .Chart.Name }}
{{- end }}