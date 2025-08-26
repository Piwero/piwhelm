{{- /*
  Template: piwhelm.manifest.configmaps
  Renders a ConfigMap from files in config/* if enabled in values.yaml
  Usage: Fails fast if required values are missing. Uses sensible defaults.
*/}}
{{- define "piwhelm.manifest.configmaps" }}
{{ $dict := (get .Values.global .Chart.Name )}}
{{ $configMap := $dict.configMap | required "Missing configMap in values.yaml" }}
{{ if $configMap.enabled }}
{{- $files := (.Files.Glob "config/*") -}}
{{- if $files }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configMap.name | default (printf "%s-config" .Chart.Name) }}
{{- include "metadata" . | indent 2 }}
data:
{{ tpl $files.AsConfig . | indent 2 }}
{{- else }}
{{- fail "No config files found in config/* for ConfigMap" }}
{{- end }}
{{- end }}
{{- end }}