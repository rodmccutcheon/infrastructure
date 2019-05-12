#!groovy
import java.util.logging.Logger
@Grapes([
    @Grab(group='org.yaml', module='snakeyaml', version='1.17')
])
import org.yaml.snakeyaml.Yaml
import org.yaml.snakeyaml.constructor.SafeConstructor

Logger logger = Logger.getLogger("awscodebuild.groovy")

logger.info("Successfully configured AWS CodeBuild integration.")