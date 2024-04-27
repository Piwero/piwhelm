{{- define "piwhelm.manifest.configmaps" }}
{{ $dict := (get .Values.global .Chart.Name )}}
{{ if $dict.configMap.enabled }}
{{ $configMap := (get $dict .configMap )}}
{{ if (.Files.Glob "config/*") }}
apiVersion: v1
kind: ConfigMap
metadata:
    name: {{ $configMap.name | default (printf "%s-config" .Chart.Name) }}
{{- include "metadata" . | indent 4 }}
data:
{{ tpl (.Files.Glob "config/*").AsConfig . | indent 4 }}
{{- end }}
{{- end }}
{{- end }}