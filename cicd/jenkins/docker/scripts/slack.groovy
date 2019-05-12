#!groovy
import java.util.logging.Logger
import jenkins.model.Jenkins
import hudson.model.User
import hudson.security.HudsonPrivateSecurityRealm
import hudson.tasks.Mailer.UserProperty
@Grapes([
    @Grab(group='org.yaml', module='snakeyaml', version='1.17')
])
import org.yaml.snakeyaml.Yaml
import org.yaml.snakeyaml.constructor.SafeConstructor

Logger logger = Logger.getLogger("slack.groovy")
Jenkins jenkins = Jenkins.getInstance()
Yaml yaml = new Yaml(new SafeConstructor())

String configPath = System.getenv("JENKINS_CONFIG_PATH")
String configText = ''
try {
    configText = new File("${configPath}/config.yml").text
} catch (FileNotFoundException e) {
    logger.severe("Cannot find config file path @ ${configPath}/config.yml")
    jenkins.doSafeExit(null)
    System.exit(1)
}

Map slackConfig = yaml.load(configText).slack

def slack = jenkins.getExtensionList(
        jenkins.plugins.slack.SlackNotifier.DescriptorImpl.class
    )[0]

//slack.baseUrl = slackConfig.SLACK_BASE_URL
slack.teamDomain = slackConfig.team_subdomain
slack.tokenCredentialId = slackConfig.integration_token
slack.botUser = slackConfig.is_slack_bot
slack.room = slackConfig.room

slack.save()
jenkins.save()
logger.info("Successfully configured slack integration.")






/*import java.lang.System
import jenkins.model.*
import hudson.security.*
import jenkins.plugins.slack.SlackNotifier.*

def home_dir = System.getenv("JENKINS_HOME")
def properties = new ConfigSlurper().parse(new File("$home_dir/jenkins.properties").toURI().toURL())

def getPasswordCredentials(String id) {
  def all = CredentialsProvider.lookupCredentials(StandardUsernameCredentials.class)
  return all.findResult { it.id == id ? it : null }
}

properties.slack.each() { configName, slackConfig ->
	if(slackConfig.enabled) {
		println '--> Configure Slack Notifier plugin'
		def slack = Jenkins.instance.getDescriptorByType(jenkins.plugins.slack.SlackNotifier.DescriptorImpl)
		slack.teamDomain = slackConfig.slackTeamDomain
		slack.token = slackConfig.slackToken
		slack.room = slackConfig.slackRoom
		slack.save()
	}
}

import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.plugins.credentials.impl.*
import hudson.util.Secret
import java.nio.file.Files
import jenkins.model.Jenkins
import net.sf.json.JSONObject
import org.jenkinsci.plugins.plaincredentials.impl.*

// parameters
def slackCredentialParameters = [
  description:  'Slack Jenkins integration token',
  id:           'slack-token',
  secret:       '1234567890asdfghjklqwert'
]

def slackParameters = [
  slackBaseUrl:             'https://mycompany.slack.com/services/hooks/jenkins-ci/',
  slackBotUser:             'true',
  slackBuildServerUrl:      'https://jenkins.mycompany.com:8083/',
  slackRoom:                '#jenkins',
  slackSendAs:              'Jenkins',
  slackTeamDomain:          'mycompany',
  slackToken:               '',
  slackTokenCredentialId:   'slack-token'
]

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()

// get credentials domain
def domain = Domain.global()

// get credentials store
def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

// get Slack plugin
def slack = jenkins.getExtensionList(jenkins.plugins.slack.SlackNotifier.DescriptorImpl.class)[0]

// define secret
def secretText = new StringCredentialsImpl(
  CredentialsScope.GLOBAL,
  slackCredentialParameters.id,
  slackCredentialParameters.description,
  Secret.fromString(slackCredentialParameters.secret)
)

// define form and request
JSONObject formData = ['slack': ['tokenCredentialId': 'slack-token']] as JSONObject
def request = [getParameter: { name -> slackParameters[name] }] as org.kohsuke.stapler.StaplerRequest

// add credential to Jenkins credentials store
store.addCredentials(domain, secretText)

// add Slack configuration to Jenkins
slack.configure(request, formData)

// save to disk
slack.save()
jenkins.save()

*/