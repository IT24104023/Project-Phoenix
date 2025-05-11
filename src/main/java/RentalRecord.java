import java.util.List;

public class RentalRecord extends Vehicle {
    private String customerName;
    private String rentalDate;
    private String returnDate;
    private boolean returned;
    private String idCardNumber;
    private int days;
    private Payment payment;
    private List<String> addons;

    public RentalRecord(String id, String model, double rentPrice, String customerName, String rentalDate, String idCardNumber, int days, Payment payment, List<String> addons) {
        super(id, model, rentPrice, false);
        this.customerName = customerName;
        this.rentalDate = rentalDate;
        this.returnDate = null;
        this.returned = false;
        this.idCardNumber = idCardNumber;
        this.days = days;
        this.payment = payment;
        this.addons = addons;
    }
