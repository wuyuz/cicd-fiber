
podTemplate(
    label: 'pod-golang',
	cloud: "kubernetes",
    privileged: 'true',
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
						ttyEnabled: true)
    ]
) {
    node ('pod-golang') {
        environment {
              IMAGE_ID = 'cicd-fiber'
              DEPLOY_NAMESPACE_PREFIX = "cicd-fiber-dev"
              DEPLOY_YAML = "deployment/cicd-service.yaml"
              REGISTRY_PROJECT_NAME = "wuyuz"

          }

        stage('PREPARE') {
            container('golang') {  // 调用容器
                sh ("go version")
            }
        }

        stage('Build') {
            container(name: 'docker') {
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