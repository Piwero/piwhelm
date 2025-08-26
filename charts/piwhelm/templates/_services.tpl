{{- /*
  Template: piwhelm.manifest.services
  Renders Service resources from values.yaml
  Usage: Fails fast if required values are missing. Uses sensible defaults and robust referencing.
*/}}
{{- define "piwhelm.manifest.services" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- if hasKey $dict "services" }}
{{- range $dict.services }}
{{- if .enabled -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .name | required "Missing name in service" }}
{{- include "metadata" $ | indent 2 }}
spec:
  selector:
    chart: {{ $.Chart.Name }}
  type: {{ .type | default "ClusterIP" }}
  ports:
    {{- if .ports }}
    {{- toYaml .ports | nindent 4 }}
    {{- else }}
    {{- fail "No ports defined for service" }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}