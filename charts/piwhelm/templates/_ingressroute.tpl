{{- /*
  Template: piwhelm.manifest.ingressroutes
  Renders IngressRoute resources from values.yaml
  Usage: Fails fast if required values are missing. Uses sensible defaults and robust referencing.
*/}}
{{- define "piwhelm.manifest.ingressroutes" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- $namespace := .Release.Namespace }}
{{- if hasKey $dict "ingressroutes" }}
{{- range $dict.ingressroutes }}
{{- if .enabled -}}
---
apiVersion: {{ .apiVersion | default "traefik.io/v1alpha1" }}
kind: IngressRoute
metadata:
  name: {{ .name | default (printf "%s-ingressroute" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
spec:
  entrypoints:
    {{- toYaml .entryPoints | nindent 4 }}
  routes:
    {{- range .routes }}
    - match: {{ .match | required "Missing match in ingressroute route" }}
      kind: {{ .kind | default "Rule" }}
      middlewares: {{ .middlewares | default list }}
      services:
        {{- range .services }}
        {{- if .enabled }}
        - kind: {{ .kind | default "Service" }}
          name: {{ .name | required "Missing name in ingressroute service" }}
          namespace: {{ .namespace | default $namespace }}
          port: {{ .port | required "Missing port in ingressroute service" }}
        {{- end }}
        {{- end }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

