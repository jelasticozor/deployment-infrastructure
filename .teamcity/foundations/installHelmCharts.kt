package foundations

import common.scripts.readScript
import jetbrains.buildServer.configs.kotlin.BuildSteps
import jetbrains.buildServer.configs.kotlin.buildSteps.ScriptBuildStep
import jetbrains.buildServer.configs.kotlin.buildSteps.script

fun BuildSteps.installHelmCharts(workingDir: String, dockerToolsTag: String): ScriptBuildStep {
    return script {
        name = "Install Helm Charts"
        scriptContent = readScript(listOf(
            "common/jelastic/connect_cluster.sh",
            "foundations/install_helm_charts.sh",
        ))
        this.workingDir = workingDir
        dockerImage = "%system.docker-registry.group%/docker-tools/devspace:$dockerToolsTag"
        dockerPull = true
        dockerImagePlatform = ScriptBuildStep.ImagePlatform.Linux
    }
}