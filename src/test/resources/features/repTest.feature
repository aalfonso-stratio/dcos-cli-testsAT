@rest
Feature: Test examples replacement
	
	Background: Setup Sparta REST client
		Given I send requests to '${SPARTA_HOST}:${SPARTA_API_PORT}'
		
	Scenario: Add 
		Given I send a 'POST' request to '/fragment' based on 'schemas/fragments/fragment.conf' as 'json' with:
                | id | DELETE | N/A |
                | fragmentType | UPDATE | input |
                | name | UPDATE | inputfragment1 |
                Then the service response status must be '200'.
		And I save element '$.id' in environment variable 'previousFragmentID'
		
	Scenario Outline: Test
                When I send a 'GET' request to '<endpoint>'
                Then the service response status must be '<value>'.

		Examples:
		| endpoint                 | value |
		| /fragment/${ENDPOINT1}   | 200 |
		| /fragment/${ENDPOINT2}   | 200 |
		| /fragment/input/!{previousFragmentID}	   | 200 |
		| /fragment/@{IP.${IFACE}} | 500 |
