{{ define "metadata" }}
{{- include "namespace" . }}
{{- include "labels" . }}
{{- end }}

{{ define "namespace" }}
namespace: {{ .Release.Namespace }}
{{- end }}

{{ define "labels" }}
labels:
    chart: {{ .Chart.Name }}
    release: {{ .Release.Name }}
    version: {{ .Chart.Version }}
{{- end }}