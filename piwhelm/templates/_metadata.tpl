{{ define "metadata" }}
namespace: {{ .Release.Namespace }}
{{ include "labels" . }}
{{- end }}

{{ define "labels" }}
chart: {{ .Chart.Name }}
release: {{ .Release.Name }}
version: {{ .Chart.Version }}
{{- end }}