{{- /*
  Template: spec
  Renders selector for resources, matching chart name.
*/}}
{{- define "spec" }}
{{- include "selector" . }}
{{- end }}

{{- /*
  Template: selector
  Renders matchLabels selector for resources, matching chart name.
*/}}
{{- define "selector" }}
selector:
  matchLabels:
    chart: {{ .Chart.Name | required "Missing Chart.Name in selector" }}
{{- end }}