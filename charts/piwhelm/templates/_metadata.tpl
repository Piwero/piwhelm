{{ define "metadata" }}
{{- include "namespace" . }}
{{- include "labels" . }}
{{- end }}

{{ define "namespace" }}
namespace: {{ .Release.Namespace }}
{{- end }}

{{ define "labels" }}
labels:
    {{- include "label-values" . }}
{{- end }}

{{ define "label-values" }}
{{- $dict := (get .Values.global .Chart.Name) }}
    chart: {{ .Chart.Name }}
    release: {{ .Release.Name }}
    version: {{ .Chart.Version }}
    {{- if $dict.extraLabels }}
    {{- toYaml $dict.extraLabels | nindent 4 }}
    {{- end }}
{{- end }}