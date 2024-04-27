{{- define "piwhelm.manifest.configmaps" }}
{{ $dict := (get .Values.global .Chart.Name )}}
{{ if $dict.configMap.enabled }}
{{ if (.Files.Glob "config/*") }}
apiVersion: v1
kind: ConfigMap
metadata:
{{- if hasKey $dict "configMap" }}
    name: {{ $dict.configMap.name | default (printf "%s-config" .Chart.Name) }}
{{- else }}
    name: {{ .Chart.Name }}-config
{{- end }}
{{- include "metadata" . | indent 4 }}
data:
{{ tpl (.Files.Glob "config/*").AsConfig . | indent 4 }}
{{- end }}
{{- end }}
{{- end }}