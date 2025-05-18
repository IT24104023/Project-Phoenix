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
