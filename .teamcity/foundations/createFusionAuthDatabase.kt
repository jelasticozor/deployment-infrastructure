package foundations

import jetbrains.buildServer.configs.kotlin.BuildSteps
import jetbrains.buildServer.configs.kotlin.buildSteps.ScriptBuildStep
import jetbrains.buildServer.configs.kotlin.buildSteps.script

fun BuildSteps.createFusionAuthDatabase(workingDir: String): ScriptBuildStep {
    return script {
        name = "Create FusionAuth Database"
        scriptContent = """
            #! /bin/sh
            set -e
            ./create_fusionauth_db.sh
        """.trimIndent()
        this.workingDir = workingDir
        dockerPull = true
        dockerImage = "%system.docker-registry.group%/governmentpaas/psql:latest"
        dockerImagePlatform = ScriptBuildStep.ImagePlatform.Linux
        dockerRunParameters = "-v /var/run/docker.sock:/var/run/docker.sock"
    }
}
