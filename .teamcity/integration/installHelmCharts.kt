package integration

import jetbrains.buildServer.configs.kotlin.BuildSteps
import jetbrains.buildServer.configs.kotlin.buildSteps.ScriptBuildStep
import jetbrains.buildServer.configs.kotlin.buildSteps.script

fun BuildSteps.installHelmCharts(workingDir: String, dockerToolsTag: String): ScriptBuildStep {
    return script {
        name = "Install Helm Charts"
        scriptContent = """
            #! /bin/sh
            
            set -e
            
            ./connect_cluster.sh jelasticozor-engine ${'$'}{KUBERNETES_API_URL} ${'$'}{KUBERNETES_API_TOKEN}
            
            ./mailhog/install.sh
            ./faas/install.sh
            ./iam/install.sh
            ./mq/install.sh
            ./vault/install.sh
        """.trimIndent()
        this.workingDir = workingDir
        dockerImage = "%system.docker-registry.group%/docker-tools/devspace:$dockerToolsTag"
        dockerPull = true
        dockerImagePlatform = ScriptBuildStep.ImagePlatform.Linux
    }
}