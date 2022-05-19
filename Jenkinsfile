pipeline{
    agent none
    options {
        disableConcurrentBuilds()
    }
    environment{
        PROJECT_NAME = 'Futgolazo APP MAIN'
		REGISTRY_PASS = credentials('alquimiabot-registry-pass')
        ARTIFACTORY_PASS = credentials('alquimiabot-artifactory-pass')
        GPG_PASS = credentials('futgolazo-app-jks')
    }
    stages{
        stage ('Notify start') {
            steps {
                rocketSend channel: 'futgolazo-builds', message: ':robot: Starting Futgolazo-MAIN-APP build :robot:'
            }
        }
        stage('Starting Test'){
            agent{
                docker{
                    image 'cirrusci/flutter'
                    label 'docker'
                }
            }
            stages{                
                stage('Build application integration'){
                    when {
                        anyOf {
                            branch 'develop'
                            branch 'hotfix/**'
                            branch 'feature/**'
                        }
                    }
                    steps{
                        sh 'echo $GPG_PASS | gpg --batch --yes --passphrase-fd 0 --output futgolazo-app.jks -d ./cert/key.jks.gpg'
                        sh 'echo keytool -exportcert -alias Futgolazo -keystore futgolazo-app.jks -storepass $GPG_PASS | openssl sha1 -binary | openssl base64'
                        sh 'flutter build apk --release --extra-front-end-options=-Ddart.vm.product=false'                        
                    }
                    
                }
                stage('Build application production'){
                    when {
                        anyOf {
                            branch 'master'
                        }
                    }
                    steps{
                        sh 'echo $GPG_PASS | gpg --batch --yes --passphrase-fd 0 --output futgolazo-app.jks -d ./cert/key.jks.gpg' 
                        sh 'echo keytool -exportcert -alias Futgolazo -keystore futgolazo-app.jks -storepass $GPG_PASS | openssl sha1 -binary | openssl base64'                       
                        sh 'flutter build apk --release --extra-front-end-options=-Ddart.vm.product=true'
                    }
                }
                stage('Stash Files Int'){
                    when {
                        anyOf {
                            branch 'develop'
                            branch 'hotfix/**'
                            branch 'feature/**'
                        }
                    }
                    steps{
                        stash includes: 'build/app/outputs/apk/release/', name: 'build'
                    }
                }
                stage('Stash Files Prod'){
                    when {
                        anyOf {
                            branch 'master'
                        }
                    }
                    steps{
                        stash includes: 'build/app/outputs/apk/release/', name: 'build'
                    }
                }
                stage('Send to Artifact Int'){
                    when{
                        anyOf {
                            branch 'develop'
                        }
                    }
                    steps{
                        unstash 'build'
                        sh 'curl -u $ARTIFACTORY_USER:$ARTIFACTORY_PASS -X PUT "https://artifact.alquimiasoft.com.ec/artifactory/libs-release/ec/com/alquimiasoft/futgolazo-main-int.apk" -T build/app/outputs/apk/release/app-release.apk'
                    }
                }
                stage('Send to Artifact Prod'){
                    when{
                        anyOf {
                            branch 'master'
                        }
                    }
                    steps{
                        unstash 'build'
                        sh 'curl -u $ARTIFACTORY_USER:$ARTIFACTORY_PASS -X PUT "https://artifact.alquimiasoft.com.ec/artifactory/libs-release/ec/com/alquimiasoft/futgolazo-apk/futgolazo-main-prod.apk" -T build/app/outputs/apk/release/app-release.apk'
                    }
                }
                
            }
            
            post {
                success {
                    script {
                        rocketSend channel: 'futgolazo-builds', message: ':white_check_mark: Build successfully MAIN APP done :white_check_mark:'
                    }
                }
                failure {
                    script {
                        rocketSend channel: 'futgolazo-builds', message: ':rotating_light: Build failed  MAIN APP :rotating_light:'
                    }
                }
            }
        }
    }
}
