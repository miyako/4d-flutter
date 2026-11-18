//%attributes = {}
var $company : cs.CompaniesEntity
var $person : cs.PeopleEntity
var $status : Object

If (ds.Companies.all().length=0)
	$company:=ds.Companies.new()
	$company.companyName:="Acme 4D"
	$status:=$company.save()
	ASSERT($status.success; "could not save Companies entity")

	$person:=ds.People.new()
	$person.firstName:="Ada"
	$person.lastName:="Lovelace"
	$person.companyID:=$company.ID
	$status:=$person.save()
	ASSERT($status.success; "could not save first People entity")

	$person:=ds.People.new()
	$person.firstName:="Grace"
	$person.lastName:="Hopper"
	$person.companyID:=$company.ID
	$status:=$person.save()
	ASSERT($status.success; "could not save second People entity")
End if

ASSERT(ds.People.all().length=2; "unexpected People entity count")
LOG EVENT(6; "PASS: reference data ready"; 0)
QUIT 4D
