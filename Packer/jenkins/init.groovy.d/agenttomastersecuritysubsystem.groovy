import jenkins.security.s2m.AdminWhitelistRule
import hudson.ExtensionList

ExtensionList.lookup(jenkins.security.s2m.AdminWhitelistRule)[0].setMasterKillSwitch(false)
