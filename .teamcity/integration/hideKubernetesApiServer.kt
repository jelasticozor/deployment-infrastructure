package integration

import common.jelastic.createEnvironment
import jetbrains.buildServer.configs.kotlin.BuildSteps
import jetbrains.buildServer.configs.kotlin.buildSteps.PythonBuildStep

fun BuildSteps.hideKubernetesApiServer(
    envName: String,
    dockerToolsTag: String,
): PythonBuildStep {
    return createEnvironment(
        envName = envName,
        manifestUrl = "https://raw.githubusercontent.com/jelasticozor/deployment-infrastructure/main/kubernetes/close_api.yaml",
        dockerToolsTag = dockerToolsTag,
    )
}