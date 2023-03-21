apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    app: dcanadillas-demo
    #myapp: dcanadillas-demo
    tier: front
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dcanadillas-demo
      tier: front
  template:
    metadata:
      labels:
        app: dcanadillas-demo
        tier: front
        myapp: dcanadillas-demo
      annotations:
        consul.hashicorp.com/connect-inject: "true"
        consul.hashicorp.com/connect-service: "frontend"
        consul.hashicorp.com/service-tags: v1.1-amd64
        # consul.hashicorp.com/connect-service-upstreams: "backend:9090"
    spec:
      serviceAccountName: frontend
      containers:
        - name: frontend
          image: hcdcanadillas/pydemo-front:v1.1-amd64
          imagePullPolicy: Always
          ports:
            - name: http
              containerPort: 8080
          env:
            # %{ for k,v in entrypoint.env }
            # - name: ${k}
            #   value: "${v}"
            # %{ endfor }
            - name: PORT
              value: "8080"
            - name: BACKEND_URL
              value: "http://backend:8080"
      #     - name: DB_USERNAME
      #       valueFrom:
      #         secretKeyRef:
      #           name: vault-db-pass-secret
      #           key: username
      #     - name: DB_PASSWORD
      #       valueFrom:
      #         secretKeyRef:
      #           name: vault-db-pass-secret
      #           key: password
      #   volumeMounts:
      #       - name: 'secrets-store-inline'
      #         mountPath: '/mnt/secrets-store'
      #         readOnly: true
      # volumes:
      #   - name: secrets-store-inline
      #     csi:
      #       driver: secrets-store.csi.k8s.io
      #       readOnly: true
      #       volumeAttributes:
      #         secretProviderClass: "vault-database"