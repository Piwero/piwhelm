{{- define "piwhelm.manifest.deployment" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- $secrets := $dict.secrets }}
{{- $configMap := $dict.configMap }}
{{- $deployment := $dict.deployment }}
{{- $containers := $deployment.containers }}
{{- if $deployment.enabled -}}
apiVersion: {{ $deployment.apiVersion }}
kind: Deployment
metadata:
  name: {{ $deployment.name | default (printf "%s-deploy" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
spec:
    replicas: {{ $deployment.replicas }}
    {{- include "selector" $ | indent 4 }}
    template:
        metadata:
    {{- include "labels" $ | indent 10 }}
        spec:
            {{- if $deployment.nodeSelector }}
            nodeSelector:
            {{- $deployment.nodeSelector | toYaml | nindent 14 }}{{- end }}
            {{- end }}
{{- if $deployment.enabled }}
            containers:
        {{- range $containers }}
        {{- if .enabled }}
              - name: {{ .name }}
                image: {{ .image }}
                imagePullPolicy: {{ .imagePullPolicy | default "IfNotPresent" }}
                {{- if .securityContext }}
                securityContext:
                  {{- .securityContext | toYaml | nindent 18 -}}{{- end }}
                {{- end }}

              {{- if or $configMap.enabled $secrets.otherSecrets }}
                envFrom:
                {{- if $configMap.enabled }}
                - configMapRef:
                    name: {{ $configMap.name }}{{- end }}
                {{- end }}
              {{- if $secrets.otherSecrets }}
              {{ $otherSecrets := $secrets.otherSecrets }}
              {{- range $otherSecrets  }}
                - secretRef:
                    name: {{ .name }}{{- end }}
              {{- end }}
              {{- end }}
                {{- if .ports }}
                ports:
                {{- range .ports }}
                - containerPort: {{ .containerPort }}
                  name: {{ .name }}
                   {{- if .protocol }}
                  protocol: {{ .protocol }}{{- end }}
                  {{- end }}
            {{- end }}
                {{- if .volumeMounts }}
                volumeMounts:
                {{- range .volumeMounts }}
                    - name: {{ .name }}
                      mountPath: {{ .mountPath }}{{- end }}
                {{- end }}
                {{- end }}
         {{- if $deployment.volumes }}
         {{- $volumes := $deployment.volumes }}
            volumes:
            {{- range $volumes }}
                - name: {{ .name}}
                  {{ if .emptyDir -}}
                  emptyDir: {}
                  {{- else -}}
                  persistentVolumeClaim:
                    claimName: {{ .persistentVolumeClaim  }}{{- end }}
                  {{- end -}}
            {{- end }}
        {{- if $secrets.imageCredentials.enabled }}
            imagePullSecrets:
                - name: {{ $secrets.imageCredentials.name }}{{- end }}
        {{- end }}

