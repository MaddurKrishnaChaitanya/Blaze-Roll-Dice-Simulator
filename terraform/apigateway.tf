# API Gateway
resource "aws_api_gateway_rest_api" "role_dice_api" {
  name = "RollDiceAPI"
  description = "This is Roll Dice Simulation API to trigger lambda function"
}