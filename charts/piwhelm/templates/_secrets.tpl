{{- define "piwhelm.manifest.otherSecrets" }}
{{ $dict := (get .Values.global .Chart.Name )}}
{{ $secrets := $dict.secrets }}
{{ $otherSecrets := $secrets.otherSecrets }}
{{- range  $otherSecrets }}
{{- if .enabled }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .name | default (printf "%s-secret" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
type: {{ .type}}
data:
  {{- range $key, $val := .data }}
    {{ $key }}: "{{ $val | b64enc }}"
  {{- end }}
{{- end }}
{{- end }}
{{- end }}


