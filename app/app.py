import os  # <-- ADDED THIS
from flask import Flask, jsonify, request

app = Flask(__name__)

expenses = []
expense_id = 1

@app.route("/health")
def health():
    return jsonify({
        "status": "UP",
        "service": "expense-tracker"
    })

@app.route("/expenses", methods=["POST"])
def create_expense():
    global expense_id
    data = request.get_json()

    # CHANGE 1: Simple check to stop the app from crashing
    if not data or "title" not in data or "amount" not in data or "category" not in data:
        return jsonify({"error": "Please provide title, amount, and category"}), 400

    expense = {
        "id": expense_id,
        "title": data["title"],
        "amount": data["amount"],
        "category": data["category"]
    }

    expenses.append(expense)
    expense_id += 1

    return jsonify(expense), 201

@app.route("/expenses", methods=["GET"])
def list_expenses():
    return jsonify(expenses)

@app.route("/summary")
def summary():
    total = sum(exp["amount"] for exp in expenses)

    return jsonify({
        "count": len(expenses),
        "total_expenses": total
    })

if __name__ == "__main__":
    # CHANGE 2: Let the cloud environment decide the port
    port = int(os.environ.get("PORT", 5000))
    app.run(
        host="0.0.0.0",
        port=port
    )