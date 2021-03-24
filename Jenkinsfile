
podTemplate(
    label: 'pod-cicd',
	cloud: "kubernetes",
    containers: [    // 添加容器
        containerTemplate(
            name: 'golang',
            image: 'golang',
            ttyEnabled: true,
            command: 'cat'
            ),
        containerTemplate(
						name: 'docker',
						image: 'docker',
						command: 'cat',
						ttyEnabled: true
			)
    ],
    envVars:[
            envVar(key: "IMAGE_ID", value: "cicd-fiber"),
            envVar(key: "DEPLOY_NAMESPACE_PREFIX", value: "cicd-fiber-dev"),
            envVar(key: "DEPLOY_YAML", value: "deployment/cicd-service.yaml"),
            envVar(key: "REGISTRY_PROJECT_NAME", value: "wuyuz"),
            envVar(key: "IMAGE_TAG", value: "V1")
    ]
) {
    node ('pod-cicd') {
        stage('PREPARE') {
            container('golang') {  // 调用容器
                sh ("go version")
            }
        }

        stage('Build') {
            sh 'printenv'
            container(name: 'docker') {
                      sh 'git clone https://github.com/wuyuz/cicd-fiber.git'
                      sh 'cd cicd-fiber'
                      sh 'ls'
                      sh 'docker build . --file Dockerfile --tag ${IMAGE_ID}:${IMAGE_TAG}'
                      sh 'echo "${REGISTRY_PASSWORD}" | docker login "${REGISTRY_HOST}" -u "${REGISTRY_USERNAME}" --password-stdin'
                      sh 'docker tag ${IMAGE_ID}:${IMAGE_TAG}  ${REGISTRY_HOST}/${REGISTRY_PROJECT_NAME}/${IMAGE_ID}:${IMAGE_TAG}'
                      sh 'docker push "${REGISTRY_HOST}"/${REGISTRY_PROJECT_NAME}/${IMAGE_ID}:${IMAGE_TAG}'
            }
        }
    }


    node('k8s') {   // 部署环境
       withKubeConfig([credentialsId: ${KUBERNETES_CREDENTIALS_ID},serverUrl: ${KUBERNETES_URL}]) {
		      sh ('kubectl get nodes')
	       }
    }

     post {
         success {
//              slackSend (color: "#67C23A", message: "Build ${env.IMAGE_ID}:${env.IMAGE_TAG} succeed. (<${env.BUILD_URL}|Open>) \n Message: ${env.GIT_COMMIT_MSG} ")
            sh 'printenv'
         }
         failure {
//              slackSend (color: "#F56C6C", message: "Build ${env.IMAGE_ID}:${env.IMAGE_TAG} failed. (<${env.BUILD_URL}|Open>) \n Message: ${env.GIT_COMMIT_MSG} ")
            sh 'printenv'
         }
     }
}