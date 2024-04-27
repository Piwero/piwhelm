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
{{ toYaml .entryPoints | indent 6 }}
    routes:
{{- range .routes }}
      - match: {{ .match }}
        kind: {{ .kind }}
        middlewares: {{ .middlewares }}
        services:
{{- range .services }}
{{- if .enabled }}
          - kind: {{ .kind }}
            name: {{ .name }}
            namespace: {{ .namespace | default $namespace }}
            port: {{ .port }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

