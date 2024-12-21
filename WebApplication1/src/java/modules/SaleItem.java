package modules; // Ensure this matches the package name where the SaleItem class is located

public class SaleItem {
    private int itemId;
    private String itemName;
    private int quantity;
    private double pricePerOne;
    private double totalPrice;

    public SaleItem(int itemId, String itemName, int quantity, double pricePerOne, double totalPrice) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.pricePerOne = pricePerOne;
        this.totalPrice = totalPrice;
    }

    public int getItemId() {
        return itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getPricePerOne() {
        return pricePerOne;
    }

    public double getTotalPrice() {
        return totalPrice;
    }
}
