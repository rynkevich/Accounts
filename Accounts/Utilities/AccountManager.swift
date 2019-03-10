import CoreData

class AccountManager {
    
    private let container: NSPersistentContainer
    
    init(_ container: NSPersistentContainer) {
        self.container = container
    }

    public func getLoggedInUserAccount() throws -> AccountManagedObject? {
        let dataContext = container.viewContext
        
        let currentUser = UserDefaults.standard.string(forKey: "currentUser")
        if currentUser == nil {
            return nil
        }
        
        let getCurrentUserAccountRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        getCurrentUserAccountRequest.predicate = NSPredicate(format: "email == %@", currentUser!)
        
        return try (dataContext.fetch(getCurrentUserAccountRequest) as! [AccountManagedObject])[0]
    }
    
    public func areValidCredentials(email: String, passwordHash: String) throws -> Bool {
        let dataContext = container.viewContext
        
        let getMatchingAccountRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        getMatchingAccountRequest.predicate = NSPredicate(
            format: "(email == %@) AND (passwordHash == %@)",
            email, passwordHash)
        
        return !(try (dataContext.fetch(getMatchingAccountRequest) as! [AccountManagedObject]).isEmpty)
    }
    
    public func isUniqueEmail(_ email: String) throws -> Bool {
        let dataContext = container.viewContext
        
        let getAccountWithEmailRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        getAccountWithEmailRequest.predicate = NSPredicate(format: "email == %@", email)
        
        return (try (dataContext.fetch(getAccountWithEmailRequest) as! [AccountManagedObject]).isEmpty)
    }
    
    public func isUniqueUsername(_ username: String) throws -> Bool {
        let dataContext = container.viewContext
        
        let getAccountWithUsernameRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        getAccountWithUsernameRequest.predicate = NSPredicate(format: "username == %@", username)
        
        return (try (dataContext.fetch(getAccountWithUsernameRequest) as! [AccountManagedObject]).isEmpty)
    }
    
    public func getAccountList() throws -> [AccountManagedObject] {
        let dataContext = container.viewContext
        
        let getAccountsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        
        let loggedInUserEmail = UserDefaults.standard.string(forKey: "currentUser")
        if loggedInUserEmail != nil {
            getAccountsRequest.predicate = NSPredicate(format: "email != %@", loggedInUserEmail!)
        }
        
        return try (dataContext.fetch(getAccountsRequest) as! [AccountManagedObject])
    }
    
}
