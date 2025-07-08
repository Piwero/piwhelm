{{- define "piwhelm.manifest.externalSecrets" }}
{{ $dict := (get .Values.global .Chart.Name )}}
{{- if hasKey $dict "externalSecrets" }}
{{ $externalSecrets := $dict.externalSecrets }}
{{- range  $externalSecrets }}
---
apiVersion: {{ .apiVersion | default "external-secrets.io/v1" }}
kind: ExternalSecret
metadata:
  name: {{ .name | default (printf "%s-external-secret" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
spec:
  secretStoreRef:
    kind: {{ .kind | default "ClusterSecretStore" }}
    name: {{ .storeName | default "kubernetes" }}
  target:
    creationPolicy: Owner
  data:
    {{- range .data }}
    - secretKey: {{ .secretKey }}
      remoteRef:
        key: {{ .remoteRef.key }}
        property: {{ .remoteRef.property }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}
---
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


