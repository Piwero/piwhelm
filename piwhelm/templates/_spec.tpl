{{- define "spec" }}
{{ $dict := (get .Values.global .Chart.Name )}}
{{- include "selector" . }}
{{- end }}

{{- define "selector" }}
selector:
    matchLabels:
        chart: {{ .Chart.Name }}
{{- end }}