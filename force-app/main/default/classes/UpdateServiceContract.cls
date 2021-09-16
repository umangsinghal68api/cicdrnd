global class UpdateServiceContract {
	// Class method to renumber Line Items for a given Invoice number.
   // Returns a string that indicates success or failure.
   webservice static String renumberLineItems(Id scId) {
		ServiceContract sc = new ServiceContract();
        system.Debug('ServiceContractClass ' + sc);
        sc = [Select Id, Sum_Currency__c  from ServiceContract where Id =: scId];
		update sc;

      return 'Line items renumbered successfully.';
   }
}