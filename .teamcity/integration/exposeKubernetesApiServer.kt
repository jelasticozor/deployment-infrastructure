package integration

import common.jelastic.createEnvironment
import jetbrains.buildServer.configs.kotlin.BuildSteps
import jetbrains.buildServer.configs.kotlin.buildSteps.PythonBuildStep

fun BuildSteps.exposeKubernetesApiServer(
    envName: String,
    envPropsQueries: List<Pair<String, String>>? = null,
    dockerToolsTag: String,
): PythonBuildStep {
    return createEnvironment(
        envName = envName,
        manifestUrl = "https://raw.githubusercontent.com/jelasticozor/deployment-infrastructure/main/kubernetes/open_api.yaml",
        dockerToolsTag = dockerToolsTag,
        envPropsQueries = envPropsQueries,
    )
}