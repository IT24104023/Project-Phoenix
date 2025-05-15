import java.io.*;
import java.util.Arrays; // Added for Arrays.asList
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

public class VehicleDataManager {
    private static final String VEHICLE_FILE = "/vehicles.txt";
    private static final String RENTAL_FILE = "/rentals.txt";
    private static final String VEHICLE_FILE_WRITABLE = "vehicles.txt";
    private static final String RENTAL_FILE_WRITABLE = "rentals.txt";
    private LinkedList<RentalRecord> rentalRecords = new LinkedList<>();

    public void createVehicle(Vehicle vehicle) throws IOException {
        File file = new File(VEHICLE_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(vehicle.getId() + "," + vehicle.getModel() + "," +
                    vehicle.getRentPrice() + "," + vehicle.isAvailable() + "," + vehicle.getCategory());
            writer.newLine();
        }
    }

    public Vehicle[] readVehicles() throws IOException {
        LinkedList<Vehicle> vehicles = new LinkedList<>();
        File writableFile = new File(VEHICLE_FILE_WRITABLE);
        boolean writableFileOutdated = false;

        if (writableFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(writableFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (!line.trim().isEmpty()) {
                        String[] parts = line.split(",");
                        if (parts.length == 5) {
                            vehicles.add(new Vehicle(parts[0], parts[1],
                                    Double.parseDouble(parts[2]), Boolean.parseBoolean(parts[3]), parts[4]));
                        } else if (parts.length == 4) {
                            writableFileOutdated = true;
                            break;
                        }
                    }
                }
            }
            if (!vehicles.isEmpty() && !writableFileOutdated) {
                return vehicles.toArray(new Vehicle[0]);
            }
        }

        vehicles.clear();
        try (InputStream is = getClass().getResourceAsStream(VEHICLE_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            if (is == null) {
                writableFile.createNewFile();
                return new Vehicle[0];
            }
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] parts = line.split(",");
                    if (parts.length == 5) {
                        vehicles.add(new Vehicle(parts[0], parts[1],
                                Double.parseDouble(parts[2]), Boolean.parseBoolean(parts[3]), parts[4]));
                    } else if (parts.length == 4) {
                        vehicles.add(new Vehicle(parts[0], parts[1],
                                Double.parseDouble(parts[2]), Boolean.parseBoolean(parts[3])));
                    }
                }
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(writableFile))) {
                for (Vehicle v : vehicles) {
                    writer.write(v.getId() + "," + v.getModel() + "," +
                            v.getRentPrice() + "," + v.isAvailable() + "," + v.getCategory());
                    writer.newLine();
                }
            }
        }
        return vehicles.toArray(new Vehicle[0]);
    }

    public void updateVehicle(Vehicle updatedVehicle) throws IOException {
        Vehicle[] vehicles = readVehicles();
        File file = new File(VEHICLE_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            boolean found = false;
            for (Vehicle v : vehicles) {
                if (v.getId().equals(updatedVehicle.getId())) {
                    writer.write(updatedVehicle.getId() + "," + updatedVehicle.getModel() + "," +
                            updatedVehicle.getRentPrice() + "," + updatedVehicle.isAvailable() + "," +
                            updatedVehicle.getCategory());
                    found = true;
                } else {
                    writer.write(v.getId() + "," + v.getModel() + "," +
                            v.getRentPrice() + "," + v.isAvailable() + "," + v.getCategory());
                }
                writer.newLine();
            }
            if (!found) {
                writer.write(updatedVehicle.getId() + "," + updatedVehicle.getModel() + "," +
                        updatedVehicle.getRentPrice() + "," + updatedVehicle.isAvailable() + "," +
                        updatedVehicle.getCategory());
                writer.newLine();
            }
        }
    }

    public void deleteVehicle(String id) throws IOException {
        Vehicle[] vehicles = readVehicles();
        File file = new File(VEHICLE_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (Vehicle v : vehicles) {
                if (!v.getId().equals(id)) {
                    writer.write(v.getId() + "," + v.getModel() + "," +
                            v.getRentPrice() + "," + v.isAvailable() + "," + v.getCategory());
                    writer.newLine();
                }
            }
        }
    }

    public void rentVehicle(RentalRecord record) throws IOException {
        rentalRecords.add(record);
        File file = new File(RENTAL_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(record.getId() + "," + record.getModel() + "," +
                    record.getRentPrice() + "," + record.getCustomerName() + "," +
                    record.getIdCardNumber() + "," + record.getRentalDate() + "," +
                    (record.getReturnDate() != null ? record.getReturnDate() : "") + "," +
                    record.isReturned() + "," + record.getDays() + "," +
                    (record.getPayment() != null ? record.getPayment().getMethod() : "") + "," +
                    (record.getAddons() != null ? String.join(";", record.getAddons()) : ""));
            writer.newLine();
        }
    }

    public LinkedList<RentalRecord> getRentalRecords() throws IOException {
        rentalRecords.clear();
        File writableFile = new File(RENTAL_FILE_WRITABLE);

        if (writableFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(writableFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (!line.trim().isEmpty()) {
                        String[] parts = line.split(",");
                        if (parts.length >= 9) {
                            Payment payment = parts[9].isEmpty() ? null : new Payment(parts[9], null, null);
                            List<String> addons = parts.length > 10 && !parts[10].isEmpty() ?
                                    Arrays.asList(parts[10].split(";")) : null;
                            RentalRecord record = new RentalRecord(parts[0], parts[1],
                                    Double.parseDouble(parts[2]), parts[3], parts[5], parts[4],
                                    Integer.parseInt(parts[8]), payment, addons);
                            if (parts.length > 6 && !parts[6].isEmpty()) {
                                record.setReturnDate(parts[6]);
                            }
                            if (parts.length > 7) {
                                record.setReturned(Boolean.parseBoolean(parts[7]));
                            }
                            rentalRecords.add(record);
                        }
                    }
                }
            }
            return rentalRecords;
        }

        try (InputStream is = getClass().getResourceAsStream(RENTAL_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            if (is == null) {
                writableFile.createNewFile();
                return rentalRecords;
            }
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] parts = line.split(",");
                    if (parts.length >= 9) {
                        Payment payment = parts[9].isEmpty() ? null : new Payment(parts[9], null, null);
                        List<String> addons = parts.length > 10 && !parts[10].isEmpty() ?
                                Arrays.asList(parts[10].split(";")) : null;
                        RentalRecord record = new RentalRecord(parts[0], parts[1],
                                Double.parseDouble(parts[2]), parts[3], parts[5], parts[4],
                                Integer.parseInt(parts[8]), payment, addons);
                        if (parts.length > 6 && !parts[6].isEmpty()) {
                            record.setReturnDate(parts[6]);
                        }
                        if (parts.length > 7) {
                            record.setReturned(Boolean.parseBoolean(parts[7]));
                        }
                        rentalRecords.add(record);
                    }
                }
            }
        }
        return rentalRecords;
    }

    public void updateRentalRecord(RentalRecord updatedRecord) throws IOException {
        LinkedList<RentalRecord> records = getRentalRecords();
        File file = new File(RENTAL_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (RentalRecord r : records) {
                if (r.getId().equals(updatedRecord.getId()) && r.getRentalDate().equals(updatedRecord.getRentalDate())) {
                    writer.write(updatedRecord.getId() + "," + updatedRecord.getModel() + "," +
                            updatedRecord.getRentPrice() + "," + updatedRecord.getCustomerName() + "," +
                            updatedRecord.getIdCardNumber() + "," + updatedRecord.getRentalDate() + "," +
                            (updatedRecord.getReturnDate() != null ? updatedRecord.getReturnDate() : "") + "," +
                            updatedRecord.isReturned() + "," + updatedRecord.getDays() + "," +
                            (updatedRecord.getPayment() != null ? updatedRecord.getPayment().getMethod() : "") + "," +
                            (updatedRecord.getAddons() != null ? String.join(";", updatedRecord.getAddons()) : ""));
                } else {
                    writer.write(r.getId() + "," + r.getModel() + "," +
                            r.getRentPrice() + "," + r.getCustomerName() + "," +
                            r.getIdCardNumber() + "," + r.getRentalDate() + "," +
                            (r.getReturnDate() != null ? r.getReturnDate() : "") + "," +
                            r.isReturned() + "," + r.getDays() + "," +
                            (r.getPayment() != null ? r.getPayment().getMethod() : "") + "," +
                            (r.getAddons() != null ? String.join(";", r.getAddons()) : ""));
                }
                writer.newLine();
            }
        }
    }

    public void updatePayment(String id, String rentalDate, Payment payment) throws IOException {
        LinkedList<RentalRecord> records = getRentalRecords();
        File file = new File(RENTAL_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (RentalRecord r : records) {
                if (r.getId().equals(id) && r.getRentalDate().equals(rentalDate)) {
                    r.setPayment(payment);
                    writer.write(r.getId() + "," + r.getModel() + "," +
                            r.getRentPrice() + "," + r.getCustomerName() + "," +
                            r.getIdCardNumber() + "," + r.getRentalDate() + "," +
                            (r.getReturnDate() != null ? r.getReturnDate() : "") + "," +
                            r.isReturned() + "," + r.getDays() + "," +
                            (r.getPayment() != null ? r.getPayment().getMethod() : "") + "," +
                            (r.getAddons() != null ? String.join(";", r.getAddons()) : ""));
                } else {
                    writer.write(r.getId() + "," + r.getModel() + "," +
                            r.getRentPrice() + "," + r.getCustomerName() + "," +
                            r.getIdCardNumber() + "," + r.getRentalDate() + "," +
                            (r.getReturnDate() != null ? r.getReturnDate() : "") + "," +
                            r.isReturned() + "," + r.getDays() + "," +
                            (r.getPayment() != null ? r.getPayment().getMethod() : "") + "," +
                            (r.getAddons() != null ? String.join(";", r.getAddons()) : ""));
                }
                writer.newLine();
            }
        }
    }

    public void deletePayment(String id, String rentalDate) throws IOException {
        updatePayment(id, rentalDate, null);
    }

    public void deleteRentals(String[] selectedRentals) throws IOException {
        LinkedList<RentalRecord> records = getRentalRecords();
        File file = new File(RENTAL_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (RentalRecord r : records) {
                String key = r.getId() + "_" + r.getRentalDate();
                boolean keep = true;
                for (String selected : selectedRentals) {
                    if (key.equals(selected)) {
                        keep = false;
                        break;
                    }
                }
                if (keep) {
                    writer.write(r.getId() + "," + r.getModel() + "," +
                            r.getRentPrice() + "," + r.getCustomerName() + "," +
                            r.getIdCardNumber() + "," + r.getRentalDate() + "," +
                            (r.getReturnDate() != null ? r.getReturnDate() : "") + "," +
                            r.isReturned() + "," + r.getDays() + "," +
                            (r.getPayment() != null ? r.getPayment().getMethod() : "") + "," +
                            (r.getAddons() != null ? String.join(";", r.getAddons()) : ""));
                    writer.newLine();
                }
            }
        }
    }

    public Vehicle[] sortVehiclesByPrice(Vehicle[] vehicles) {
        for (int i = 0; i < vehicles.length - 1; i++) {
            int minIdx = i;
            for (int j = i + 1; j < vehicles.length; j++) {
                if (vehicles[j].getRentPrice() < vehicles[minIdx].getRentPrice()) {
                    minIdx = j;
                }
            }
            Vehicle temp = vehicles[minIdx];
            vehicles[minIdx] = vehicles[i];
            vehicles[i] = temp;
        }
        return vehicles;
    }
}