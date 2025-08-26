{{- /*
  Template: metadata
  Renders namespace and labels for resources. Uses extraLabels from values.yaml if present.
*/}}
{{- define "metadata" }}
{{- include "namespace" . }}
{{- include "labels" . }}
{{- end }}

{{- /*
  Template: namespace
  Renders the namespace for the resource, defaults to Helm release namespace.
*/}}
{{- define "namespace" }}
namespace: {{ .Release.Namespace }}
{{- end }}

{{- /*
  Template: labels
  Renders labels for the resource, including chart, release, version, and extraLabels.
*/}}
{{- define "labels" }}
labels:
  {{- include "label-values" . }}
{{- end }}

{{- /*
  Template: label-values
  Renders label values from values.yaml and Helm context.
*/}}
{{- define "label-values" }}
{{- $dict := (get .Values.global .Chart.Name) }}
  chart: {{ .Chart.Name }}
  release: {{ .Release.Name }}
  version: {{ .Chart.Version }}
  {{- if $dict.extraLabels }}
  {{- toYaml $dict.extraLabels | nindent 2 }}
  {{- end }}
{{- end }}