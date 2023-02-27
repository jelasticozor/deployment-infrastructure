package integration

import common.scripts.readScript
import jetbrains.buildServer.configs.kotlin.BuildSteps
import jetbrains.buildServer.configs.kotlin.buildSteps.PythonBuildStep
import jetbrains.buildServer.configs.kotlin.buildSteps.python

fun BuildSteps.updateState(
    envVar: String,
    stateFile: String,
    workingDir: String,
): PythonBuildStep {
    return python {
        name = "Update state file with '$envVar'"
        command = script {
            content = readScript("integration/update_state.py")
            scriptArguments = """
                    --env-var $envVar
                    --state-file $stateFile
                """.trimIndent()
        }
        this.workingDir = workingDir
    }
}