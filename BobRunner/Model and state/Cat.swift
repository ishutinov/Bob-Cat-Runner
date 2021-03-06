//
//  Cat.swift
//  BobRunner
//
//  Created by Horváth Balázs on 2017. 06. 16..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import SpriteKit

class Cat: SKSpriteNode {

    // MARK: Properties
    let jumpImpulse = 800
    let runSpeed = CGFloat(5)

    var lifes: Int = 5
    var isProtected = false
    var initialSize = CGSize(width: 84, height: 54)

    let dieAction = SKAction.rotate(byAngle: (.pi), duration: 0.5)
    let collectUmbrellaSound = SKAction.playSound(assetIdentifier: .collectUmbrella)
    let raindropHitCatSound = SKAction.playSound(assetIdentifier: .raindropHitCat)
    let raindropHitUmbrellaSound = SKAction.playSound(assetIdentifier: .raindropHitUmbrella)
    let gameOverSound = SKAction.playSound(assetIdentifier: .gameover)
    let celebrateSound = SKAction.playSound(assetIdentifier: .crowdCelebrate)

    // MARK: Initializers
    init(lifes: Int) {
        self.lifes = lifes
        let texture = SKTexture(assetIdentifier: .catStandRight)
        super.init(texture: texture, color: .clear, size: initialSize)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Actions
    func move(left: Bool) {
        if left {
            position.x -= runSpeed
        } else {
            position.x += runSpeed
        }
    }

    func jumpUp() {
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpImpulse))
    }

    func takeDamage() {
        lifes -= 1
        run(raindropHitCatSound)
    }

    func collect(umbrella: SKNode) {
        umbrella.removeFromParent()
        run(collectUmbrellaSound)
        isProtected = true
    }

    func isAlive() -> Bool {
        return lifes > 0
    }

    func die() {
        run(SKAction.sequence([gameOverSound, dieAction]))
        texture = SKTexture(assetIdentifier: .catDead)
        isProtected = false
    }

    func drown() {
        run(gameOverSound)
        isProtected = false
    }

    func celebrate() {
        run(celebrateSound)

        let jumpAction = SKAction.applyForce(CGVector(dx: 0, dy: 800), duration: TimeInterval(1.5))
        var jumpSequence = [SKAction]()

        (1...5).forEach { _ in
            jumpSequence.append(jumpAction)
        }

        run(SKAction.sequence(jumpSequence))
    }
}
