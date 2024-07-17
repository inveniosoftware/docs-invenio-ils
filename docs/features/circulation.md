# Circulation

InvenioILS provides comprehensive tools for managing loan circulation, including tracking and flexible delivery options.

## Checkout/Checkin

InvenioILS streamlines the checkout and checkin process for both librarians and users.

- **Checkout**: Users can check out items using the user-friendly interface, which supports barcode scanning for quick processing. The system updates the item's status to "checked out," logs the user information, and sets the due date based on library policies.

- **Checkin**: When items are returned, librarians or users can check them in through the system. The item's status is updated to "available," and the system can automatically notify the next user in the hold queue if the item was reserved.

### Circulation states

The circulation states in InvenioILS provide clarity on the status of each item:

- **Available**: The item is available for checkout.
- **On Loan**: The item is currently borrowed by a user.
- **Pending**: The item is requested for loan by a user and awaiting approval.
- **Overdue**: The item has not been returned by the due date.
- *Cancelled**: The item's loan has been cancelled.
- **Returned**: The item is returned successfully.

## Loan extensions

Users have the option to request extensions on their loans through the system. This ensures they can keep borrowed items for as long as they need them within the library's policies, which are customizable to fit the library's specific needs.

![Loan Extension](/assets/images/features/loan-extension.png)

## Delivery options

Users can have a choice on the type of delivery method provided by the library.

![Delivery Options](/assets/images/features/delivery.png)
