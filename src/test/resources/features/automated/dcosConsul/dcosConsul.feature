@rest
Feature: Test addition of consul package to cli

  Background: Setup PaaS REST client
    Given I send requests to '${DCOS_CLUSTER}:${DCOS_CLUSTER_PORT}'

  Scenario: Add package repo
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos package repo add stratio ${UNIVERSE_URL}' in remote ssh connection
    Then the command exit status is '0'
    When I execute command 'dcos package repo list | grep stratio' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'stratio'

  Scenario: Install dcos consul
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos package search consul' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'Consul CLI subcommand'
    When I execute command 'dcos package install --cli consul' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'New command available: dcos consul'

  Scenario: Test dcos consul --help
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos consul --help' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'Manage Paas Consul nodes'

  Scenario: Test dcos consul --info
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos consul --info' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'Manage Paas Consul nodes'

  Scenario:  Test dcos consul --version
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos consul --version' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'dcos-marathon version 0.1.0'

  Scenario: Test dcos consul status leader
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos consul status leader' in remote ssh connection
    Then the command exit status is '0'
    # And the command output contains ''

  Scenario: Test dcos consul status peers
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos consul status peers' in remote ssh connection
    Then the command exit status is '0'
    # And the command output contains ''

  Scenario: Test dcos consul keyvalue set and get
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos consul keyvalue set name stratians' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains 'true'
    When I execute command 'dcos consul keyvalue get name' in remote ssh connection
    Then the command exit status is '0'
    And the command output contains '"Value": "c3RyYXRpYW5z"'

  Scenario: Uninstall consul package
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos package uninstall consul' in remote ssh connection
    Then the command exit status is '0'

  Scenario: Remove universe
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    When I execute command 'dcos package repo remove stratio' in remote ssh connection
    Then the command exit status is '0'
    When I execute command 'dcos package repo list | grep stratio' in remote ssh connection
    Then the command exit status is '1'
