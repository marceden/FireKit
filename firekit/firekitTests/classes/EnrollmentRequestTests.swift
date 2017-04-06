//
//  EnrollmentRequestTests.swift
//  FireKit
//
//  Generated from FHIR 1.0.2.7202 on 2017-04-06.
//  2017, SMART Health IT.
//
// Tweaked for RealmSupport by Ryan Baldwin, University Health Network.

import XCTest
import RealmSwift
import FireKit


class EnrollmentRequestTests: XCTestCase, RealmPersistenceTesting {    
	var realm: Realm!

	override func setUp() {
		realm = makeRealm()
	}

	func instantiateFrom(_ filename: String) throws -> FireKit.EnrollmentRequest {
		return instantiateFrom(try readJSONFile(filename))
	}
	
	func instantiateFrom(_ json: FHIRJSON) -> FireKit.EnrollmentRequest {
		let instance = FireKit.EnrollmentRequest(json: json)
		XCTAssertNotNil(instance, "Must have instantiated a test instance")
		return instance
	}
	
	func testEnrollmentRequest1() {		
		var instance: FireKit.EnrollmentRequest?
		do {
			instance = try runEnrollmentRequest1()
			try runEnrollmentRequest1(instance!.asJSON()) 		
			let copy = instance!.copy() as? FireKit.EnrollmentRequest
			XCTAssertNotNil(copy)
			try runEnrollmentRequest1(copy!.asJSON())     

            try! realm.write { copy!.populate(from: instance!) }
            try runEnrollmentRequest1(copy!.asJSON())  
		}
		catch {
			XCTAssertTrue(false, "Must instantiate and test EnrollmentRequest successfully, but threw")
		}

		testEnrollmentRequestRealm1(instance!)
	}

    func testEnrollmentRequest1RealmPK() {        
        do {
            let instance: FireKit.EnrollmentRequest = try runEnrollmentRequest1()
            let copy = (instance.copy() as! FireKit.EnrollmentRequest)

            XCTAssertNotEqual(instance.pk, copy.pk)
            try! realm.write { realm.add(instance) }
            try! realm.write{ _ = instance.populate(from: copy.asJSON()) }
            XCTAssertNotEqual(instance.pk, copy.pk)
            
            let prePopulatedCopyPK = copy.pk
            _ = copy.populate(from: instance.asJSON())
            XCTAssertEqual(prePopulatedCopyPK, copy.pk)
            XCTAssertNotEqual(copy.pk, instance.pk)
        } catch let error {
            XCTAssertTrue(false, "Must instantiate and test EnrollmentRequest's PKs, but threw: \(error)")
        }
    }

	func testEnrollmentRequestRealm1(_ instance: FireKit.EnrollmentRequest) {
		// ensure we can write the instance, then fetch it, serialize it to JSON, then deserialize that JSON 
        // and ensure it passes the all the same tests.
		try! realm.write {
                realm.add(instance)
            }
        try! runEnrollmentRequest1(realm.objects(FireKit.EnrollmentRequest.self).first!.asJSON())
        
        // ensure we can update it.
        try! realm.write { instance.implicitRules = "Rule #1" }
        XCTAssertEqual(1, realm.objects(FireKit.EnrollmentRequest.self).count)
        XCTAssertEqual("Rule #1", realm.objects(FireKit.EnrollmentRequest.self).first!.implicitRules)
        
        // create a new instance with default key, save it, then populate it from instance JSON. 
        // PK should persist and not be overwritten.
        let newInst = FireKit.EnrollmentRequest()
        try! realm.write { realm.add(newInst) }
        
        // first time updating it should inflate children resources/elements which don't exist
        var existing = realm.object(ofType: FireKit.EnrollmentRequest.self, forPrimaryKey: newInst.pk)!
        try! realm.write{ _ = existing.populate(from: instance.asJSON()) }
        try! runEnrollmentRequest1(existing.asJSON())
        
        // second time updating it will overwrite values of child resources/elements, but maintain keys
        // TODO: Find a way to actually test this instead of breakpoints and eyeballing it.
        existing = realm.object(ofType: FireKit.EnrollmentRequest.self, forPrimaryKey: newInst.pk)!
        try! realm.write{ _ = existing.populate(from: instance.asJSON()) }
        try! runEnrollmentRequest1(existing.asJSON())

        try! realm.write { realm.delete(instance) }        
        XCTAssertEqual(1, realm.objects(FireKit.EnrollmentRequest.self).count)

        try! realm.write { realm.delete(existing) }
        XCTAssertEqual(0, realm.objects(FireKit.EnrollmentRequest.self).count)
	}
	
	@discardableResult
	func runEnrollmentRequest1(_ json: FHIRJSON? = nil) throws -> FireKit.EnrollmentRequest {
		let inst = (nil != json) ? instantiateFrom(json!) : try instantiateFrom("enrollmentrequest-example.json")
		
		XCTAssertEqual(inst.coverage?.reference, "Coverage/9876B1")
		XCTAssertEqual(inst.created?.description, "2014-08-16")
		XCTAssertEqual(inst.id, "22345")
		XCTAssertEqual(inst.identifier[0].system, "http://happyvalley.com/enrollmentrequest")
		XCTAssertEqual(inst.identifier[0].value, "EN22345")
		XCTAssertEqual(inst.organization?.reference, "Organization/1")
		XCTAssertEqual(inst.relationship?.code, "spouse")
		XCTAssertEqual(inst.subject?.reference, "Patient/1")
		XCTAssertEqual(inst.text?.div, "<div>A human-readable rendering of the EnrollmentRequest.</div>")
		XCTAssertEqual(inst.text?.status, "generated")
		
		return inst
	}
}
