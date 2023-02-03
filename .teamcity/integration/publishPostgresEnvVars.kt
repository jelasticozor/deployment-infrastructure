package jelastic

import common.scripts.readScript
import jetbrains.buildServer.configs.kotlin.BuildSteps
import jetbrains.buildServer.configs.kotlin.buildSteps.PythonBuildStep
import jetbrains.buildServer.configs.kotlin.buildSteps.python

fun BuildSteps.publishPostgresEnvVars(
    successTextFile: String,
    dockerToolsTag: String,
): PythonBuildStep {
    return python {
        name = "Publish Postgres Environment Variables"
        command = script {
            content = readScript("integration/publish_postgres_env_vars.py")
            scriptArguments = """
                    --success-text-file $successTextFile
                """.trimIndent()
        }
        dockerImage = "%system.docker-registry.group%/docker-tools/jelastic:$dockerToolsTag"
        dockerPull = true
        dockerImagePlatform = PythonBuildStep.ImagePlatform.Linux
        this.workingDir = workingDir
    }
}