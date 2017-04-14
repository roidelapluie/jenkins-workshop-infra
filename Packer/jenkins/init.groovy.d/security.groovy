import jenkins.model.*
import hudson.security.*
import org.jenkinsci.plugins.*

password = new File('/tmp/password')
if (password.exists()) {
    def instance = Jenkins.getInstance()

    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    hudsonRealm.createAccount("admin", password.text)
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    instance.setAuthorizationStrategy(strategy)

    instance.save()

    password.delete()
}
