package integration

import jetbrains.buildServer.configs.kotlin.BuildSteps
import jetbrains.buildServer.configs.kotlin.buildSteps.ScriptBuildStep
import jetbrains.buildServer.configs.kotlin.buildSteps.script

fun BuildSteps.publishClusterName(clusterName: String): ScriptBuildStep {
    return script {
        name = "Publish Cluster Name"
        scriptContent = """
            #! /bin/sh
            echo "##teamcity[setParameter name='env.KUBERNETES_CLUSTER_NAME' value='$clusterName']"
        """.trimIndent()
    }
}
