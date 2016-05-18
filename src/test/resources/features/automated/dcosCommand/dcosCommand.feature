@rest
Feature: Test addition of command package to cli

  Background: Setup PaaS REST client
    Given I send requests to '${DCOS_CLUSTER}:${DCOS_CLUSTER_PORT}'

  Scenario: Add package repo
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos package repo add stratio ${UNIVERSE_URL}' in remote ssh connection
    Then the command exit status is '0'
    When I execute command 'dcos package repo list | grep stratio' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'stratio'

  Scenario: Install dcos command
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos package search command' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'Command CLI subcommand'
    When I execute command 'dcos package install --cli command' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'New command available: dcos command'

  Scenario: Test dcos command --help
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos command --help' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'Administer and manage commands in DCOS cluster nodes.'

  Scenario: Test dcos command --info
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos command --info' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'Administer and manage commands in DCOS cluster nodes.'

  Scenario: Test dcos command --version
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos command --version' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'dcos-command version 0.1.0'

  Scenario: Test dcos command ssh
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    # Setup ssh passwordless
    And I setup ssh connections to nodes using user '${NODES_USER}' and password '${NODES_PASSWORD}' from '${DCOS_CLI_HOST}' in cluster '${DCOS_CLUSTER}'
    # Node: dcos command ssh --mesos-id=XXXXX 'echo $PATH'
    When I execute command 'dcos command ssh --user=root --mesos-id=$(dcos node | awk '{print $3}' | grep -v ID | head -1) "echo $PATH"' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains '/usr/bin'
    # Leader: dcos command ssh --leader 'echo $PATH'
    When I execute command 'dcos command ssh --user ${NODES_USER} --leader "echo $PATH"' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains '/usr/bin'
    # Master: dcos command ssh --master 'echo $PATH'
    When I execute command 'dcos command ssh --user ${NODES_USER} --master "echo $PATH"' in remote ssh connection
    Then the command exit status is '1'
    # Slave: dcos command ssh --slave=XXXXX 'echo $PATH'
    When I execute command 'dcos command ssh --user=root --slave=$(dcos node | awk '{print $3}' | grep -v ID | head -1) "echo $PATH"' in remote ssh connection
    Then the command exit status is '1'
    # Undo ssh passwordless
    And I undo ssh connections to nodes using user '${NODES_USER}' and password '${NODES_PASSWORD}' from '${DCOS_CLI_HOST}' in cluster '${DCOS_CLUSTER}'

  Scenario: Uninstall command package
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos package uninstall command' in remote ssh connection
    Then the command exit status is '0'

  Scenario: Remove universe
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos package repo remove stratio' in remote ssh connection
    Then the command exit status is '0'
    When I execute command 'dcos package repo list | grep stratio' in remote ssh connection
    Then the command exit status is '1'