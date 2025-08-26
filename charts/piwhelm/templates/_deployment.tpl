{{- /*
  Template: piwhelm.manifest.deployment
  Renders a Deployment manifest from values.yaml
  Usage: Fails fast if required values are missing. Uses sensible defaults and robust referencing.
*/}}
{{- define "piwhelm.manifest.deployment" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{ $deployment := $dict.deployment | required "Missing deployment in values.yaml" }}
{{ if $deployment.enabled }}
apiVersion: {{ $deployment.apiVersion | default "apps/v1" }}
kind: Deployment
metadata:
  name: {{ $deployment.name | default (printf "%s-deployment" .Chart.Name) }}
{{- include "metadata" . | indent 2 }}
spec:
  replicas: {{ $deployment.replicas | default 1 }}
  selector:
    matchLabels:
      chart: {{ .Chart.Name }}
  template:
    metadata:
      labels:
        chart: {{ .Chart.Name }}
    spec:
      nodeSelector:
        {{- toYaml $deployment.nodeSelector | nindent 8 }}
      {{- include "piwhelm.containers" $dict | indent 6 }}
      {{- include "piwhelm.envFrom" $dict | indent 6 }}
      {{- if $deployment.volumes }}
      volumes:
        {{- toYaml $deployment.volumes | nindent 8 }}
      {{- end }}
{{- end }}
{{- end }}