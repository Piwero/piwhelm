{{- define "piwhelm.containers" }}
{{- $containers := .deployment.containers }}
containers:
{{- range $containers }}
{{- if .enabled }}
  - name: {{ .name }}
    image: {{ .image }}
    imagePullPolicy: {{ .imagePullPolicy | default "IfNotPresent" }}
    {{- with .securityContext }}
    securityContext:
      {{- toYaml . | nindent 8 }}
    {{- end }}
    {{- with .ports }}
    ports:
    {{- range . }}
    - containerPort: {{ .containerPort }}
      name: {{ .name }}
      {{- with .protocol }}
      protocol: {{ . }}{{- end }}
    {{- end }}
    {{- end }}
    {{- with .volumeMounts }}
    volumeMounts:
    {{- range . }}
      - name: {{ .name }}
        mountPath: {{ .mountPath }}
    {{- end }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "piwhelm.envFrom" }}
{{- $configMap := .configMap }}
{{- $secrets := .secrets }}
{{- if or $configMap.enabled $secrets.otherSecrets }}
    envFrom:
{{- if $configMap.enabled }}
      - configMapRef:
          name: {{ $configMap.name }}
{{- end }}
{{- range $secrets.otherSecrets }}
      - secretRef:
          name: {{ .name }}
{{- end }}
{{- end }}
{{- end }}

{{- define "piwhelm.manifest.deployment" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- $secrets := $dict.secrets }}
{{- $configMap := $dict.configMap }}
{{- $deployment := $dict.deployment }}
{{- if $deployment.enabled }}
apiVersion: {{ $deployment.apiVersion }}
kind: Deployment
metadata:
  name: {{ default $deployment.name (printf "%s-deploy" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
spec:
  replicas: {{ $deployment.replicas }}
  {{- include "selector" $ | indent 2 }}
  template:
    metadata:
      {{- include "labels" $ | indent 10 }}
    spec:
      {{- with $deployment.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 10 }}
      {{- end }}
      {{- include "piwhelm.containers" (dict "deployment" $deployment) | nindent 6 }}
      {{- include "piwhelm.envFrom" (dict "configMap" $configMap "secrets" $secrets) | nindent 6 }}
      {{- with $deployment.volumes }}
      volumes:
        {{- range . }}
        - name: {{ .name }}
          {{- if .emptyDir }}
          emptyDir: {}
          {{- else }}
          persistentVolumeClaim:
            claimName: {{ .persistentVolumeClaim }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- if $secrets.imageCredentials.enabled }}
      imagePullSecrets:
        - name: {{ $secrets.imageCredentials.name }}
      {{- end }}
{{- end }}
{{- end }}